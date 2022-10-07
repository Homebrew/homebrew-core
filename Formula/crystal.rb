class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/1.6.0.tar.gz"
    sha256 "8119bc099d898be0d2e5055f783d41325a10e4b7824240272eb6ecb30c8c9a2e"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.17.0.tar.gz"
      sha256 "b3f0a2261437b21b3e2465b7755edf0c33f0305a112bd9a36e1b3ec74f96b098"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e003cfa6805ae5defd77b3dcfac1364aca21670c38fc6a68951d1bcea07622f1"
    sha256 cellar: :any,                 arm64_big_sur:  "38a2badca61f2946357040c9bf9ba6cb61cc20658ef71a37879e40f737ada920"
    sha256 cellar: :any,                 monterey:       "f3e16eb458c9d44e17945bf6453ebe8a7c81e3aa8edd7d0e908bc8caa775c83d"
    sha256 cellar: :any,                 big_sur:        "47f46be8eafa97fb4d705cfd81820c2928fcb6b60c996a4d4166e0a3178f32a3"
    sha256 cellar: :any,                 catalina:       "4761c151414ecef2a792781dcd615dbed1afe85af54ad2dc0d85f5df14caa704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec894c97a1a4cf4d5c79f3d77d8d38e5ef5ccc640831fe0fabda1f3fa2404e9"
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
      "darwin-universal" => "e7f9b3e1e866dc909a0a310238907182f1ee8b3c09bd8da5ecd0072d99c1fc5c",
      "linux-x86_64"     => "a5bdf1b78897b3cdc7d715b5f7adff79e84401d39b7ab546ab3249dc17fc770c",
    }

    if checksums.include? platform
      boot_version = Version.new("1.4.1-1")

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

    (buildpath/"boot").install resource("boot")
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

      (Pathname.pwd/"lib/molinillo").install resource("molinillo")

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

    man1.install "man/crystal.1"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
