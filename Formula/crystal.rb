class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/1.7.3.tar.gz"
    sha256 "3ad94dd2835a58af8dabf18d6cdf3791eb49cdfc6fdc6fd6a4e59abf0e860a6f"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.17.2.tar.gz"
      sha256 "ca3963512db8316b3624c0fba57f803419d67502416fe44938a27aa616cf9d70"
    end

    depends_on "llvm@14"
    depends_on "pcre"
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "208f602967b52f210e7a6b77d590ea5f0c1a75a7f2ddd4adb28e13f110e7a0b0"
    sha256 cellar: :any,                 arm64_monterey: "b3c460df2ed4da57a95eb75f44f358ed7d715cf58c26f1f3f5ca36ca0e7dd31f"
    sha256 cellar: :any,                 arm64_big_sur:  "b199016644332e2d3a07ab683c0a43d0779017ed0f9ce53c0bbcfb212d0fa2e9"
    sha256 cellar: :any,                 ventura:        "7fcb5188b52efd9bf47442ba6b0d09dd85b40c34614fc7e497507eac19370004"
    sha256 cellar: :any,                 monterey:       "9cfbbc05fe4c345e06983e8e471e01a85e6256d0d7edaba7d2abaab5b29e2cc5"
    sha256 cellar: :any,                 big_sur:        "53208361b8f7ea07ca642fb01f475d32cc18802712ad317e4f4ae6827c24f836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a37752e1a0a2eb423b18bb42b8f8aa4751bff15a92afc560a962d63f74ae02"
  end

  head do
    url "https://github.com/crystal-lang/crystal.git", branch: "master"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git", branch: "master"
    end

    depends_on "llvm"
    depends_on "pcre2"
    uses_from_macos "libffi" # for the interpreter
  end

  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@1.1" # std uses it but it's not linked
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  on_linux do
    depends_on arch: :x86_64
  end

  fails_with gcc: "5"

  # It used to be the case that every new crystal release was built from a
  # previous release, except patches. Crystal is updating its policy to
  # allow 4 minor releases of compatibility unless otherwise explicited.
  # Therefore, the boot version should have the MINOR component be
  # between the current minor - 4 and current minor - 1.
  #
  # See: https://github.com/Homebrew/homebrew-core/pull/81318
  resource "boot" do
    boot_version = Version.new("1.5.1-1")
    version boot_version

    on_macos do
      url "https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-darwin-universal.tar.gz"
      # version boot_version
      sha256 "432c2fc992247f666db7e55fb15509441510831a72beba34affa2d76b6f2e092"
    end

    on_linux do
      on_intel do
        url "https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-linux-x86_64.tar.gz"
        # version boot_version
        sha256 "a475c3d99dbe0f2d5a72d471fa25e03c124b599e47336eed746973b4b4d787bc"
      end
    end
  end

  # Check version in `shard.lock` in shards repo.
  resource "molinillo" do
    url "https://github.com/crystal-lang/crystal-molinillo/archive/refs/tags/v0.2.0.tar.gz"
    sha256 "e231cf2411a6a11a1538983c7fb52b19e650acc3338bd3cdf6fdb13d6463861a"
  end

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    non_keg_only_runtime_deps = deps.reject(&:build?)
                                    .map(&:to_formula)
                                    .reject(&:keg_only?)

    resource("boot").stage "boot"
    ENV.append_path "PATH", "boot/bin"
    ENV["LLVM_CONFIG"] = llvm.opt_bin/"llvm-config"
    ENV["CRYSTAL_LIBRARY_PATH"] = ENV["HOMEBREW_LIBRARY_PATHS"]
    ENV.append_path "CRYSTAL_LIBRARY_PATH", MacOS.sdk_path_if_needed/"usr/lib" if MacOS.sdk_path_if_needed
    non_keg_only_runtime_deps.each do |dep|
      # Our just built `crystal` won't link with some dependents (e.g. `bdw-gc`, `libevent`)
      # unless they're explicitly added to `CRYSTAL_LIBRARY_PATH`. The keg-only dependencies
      # are already in `HOMEBREW_LIBRARY_PATHS`, so there is no need to add them.
      ENV.prepend_path "CRYSTAL_LIBRARY_PATH", dep.opt_lib
    end

    crystal_install_dir = libexec
    stdlib_install_dir = pkgshare

    # Avoid embedding HOMEBREW_PREFIX references in `crystal` binary.
    config_library_path = "\\$$ORIGIN/#{HOMEBREW_PREFIX.relative_path_from(crystal_install_dir)}/lib"
    config_path = "\\$$ORIGIN/#{stdlib_install_dir.relative_path_from(crystal_install_dir)}/src"

    release_flags = ["release=true", "FLAGS=--no-debug"]
    crystal_build_opts = release_flags + [
      "CRYSTAL_CONFIG_LIBRARY_PATH=#{config_library_path}",
      "CRYSTAL_CONFIG_PATH=#{config_path}",
      "interpreter=true",
    ]
    crystal_build_opts << "CRYSTAL_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}" if build.head?

    # Build crystal
    (buildpath/".build").mkpath
    system "make", "deps"
    system "make", "crystal", *crystal_build_opts

    # Build shards (with recently built crystal)
    resource("shards").stage do
      shard_lock = YAML.load_file("shard.lock")
      required_molinillo_version = shard_lock.dig("shards", "molinillo", "version")
      available_molinillo_version = resource("molinillo").version.to_s
      odie "`molinillo` resource is outdated!" unless required_molinillo_version == available_molinillo_version

      resource("molinillo").stage "lib/molinillo"

      shards_build_opts = release_flags + [
        "CRYSTAL=#{buildpath}/bin/crystal",
        "SHARDS=false",
      ]
      shards_build_opts << "SHARDS_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}" if build.head?
      system "make", "bin/shards", *shards_build_opts

      # Install shards
      bin.install "bin/shards"
      man1.install "man/shards.1"
      man5.install "man/shard.yml.5"
    end

    # Install crystal
    crystal_install_dir.install ".build/crystal"
    stdlib_install_dir.install "src"

    pkg_config_path = "${PKG_CONFIG_PATH:+${PKG_CONFIG_PATH}:}#{Formula["openssl@1.1"].opt_lib}/pkgconfig"
    (bin/"crystal").write_env_script crystal_install_dir/"crystal", PKG_CONFIG_PATH: pkg_config_path

    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"
    fish_completion.install "etc/completion.fish" => "crystal.fish"

    man1.install "man/crystal.1"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
