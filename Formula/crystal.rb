class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/1.6.1.tar.gz"
    sha256 "f84bde9fd7b03f606bb6f711109ccadf4b90af678983b65eb2acbed48b9558ed"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.17.1.tar.gz"
      sha256 "cfae162980ef9260120f00ba530273fc2e1b595906b6d39db0cd41323f936e03"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "2a5ce97d6174e3e94cad13fd5776ea3f6d2a208a62ad8ba149cecd07e6358603"
    sha256 cellar: :any,                 arm64_big_sur:  "04da03375a7842a73596fc6f849363b7ce9aad8902e597ff7fa00118d28320d7"
    sha256 cellar: :any,                 monterey:       "aeb472a0598987e2e718d705dfd8236b9f9180ce761e08f38af7e98c09713a13"
    sha256 cellar: :any,                 big_sur:        "ac3c255659232ab1e781fbdb042b4491135eca7cc13e042adbeab22c2d47f3bc"
    sha256 cellar: :any,                 catalina:       "1a32dd19a90542f3cd4876422fca0ae66118c8a0864053df2b20697b812fac0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709cee9f8f5a1b08ddba113eb14c96693f628bd56066556cdd9d1ea2cd1eeded"
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end

    uses_from_macos "libffi" # for the interpreter
  end

  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@14"
  depends_on "openssl@1.1" # std uses it but it's not linked
  depends_on "pcre"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  on_linux do
    depends_on arch: :x86_64
  end

  fails_with gcc: "5"

  # Every new crystal release is built from the previous one. The exceptions are
  # when crystal make a minor release (only bug fixes). Reason is because those
  # bugs could make the compiler from stopping compiling the next compiler.
  #
  # See: https://github.com/Homebrew/homebrew-core/pull/81318
  resource "boot" do
    platform = case OS.kernel_name
    when "Darwin" then "darwin-universal"
    else "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}"
    end

    checksums = {
      "darwin-universal" => "432c2fc992247f666db7e55fb15509441510831a72beba34affa2d76b6f2e092",
      "linux-x86_64"     => "a475c3d99dbe0f2d5a72d471fa25e03c124b599e47336eed746973b4b4d787bc",
    }

    if checksums.include? platform
      boot_version = Version.new("1.5.1-1")

      url "https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-#{platform}.tar.gz"
      version boot_version
      sha256 checksums[platform]
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
    ]
    if build.head?
      crystal_build_opts << "interpreter=true"
      crystal_build_opts << "CRYSTAL_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}"
    end

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
