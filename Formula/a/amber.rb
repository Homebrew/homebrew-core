class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "92664a859fb27699855dfa5d87dc9bf2e4a614d3e54844a8344196d2807e775c"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "316df6cc7883f0019a4d8b7cea12981c76558ee23c91ce802d8a5a27f4e1dae3"
    sha256 arm64_sonoma:   "149fc485a57fe986e601b0072476fc7b52de0feb888dcac0e7c153459290f548"
    sha256 arm64_ventura:  "d9e1818484cce9f61edffedeb494e01f69a07d137880179f84dabef6b48b063f"
    sha256 arm64_monterey: "3b8de888365014ecb18fc427906bf5121c6f5c0b6eceaf8311ede6030b22334d"
    sha256 sonoma:         "bce2680561c7ce0a84ee72e598e4569382fe29ec44a156517c1dfd9bcc936951"
    sha256 ventura:        "e16a952e1ed4e62ab4512dbd678a85d45031a2157898d033b1a95de311619a7a"
    sha256 monterey:       "a662a8236dbfedeb36a8e291243fcd6c2c76fcb4c7aa1a2f34f7cdad6badc4f0"
    sha256 x86_64_linux:   "18ea26aa05700494f2acf965ad8db36bf9c1e8f36ca1c606091e1373effaad9d"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "zlib"

  # Temporary resource to fix build with Crystal 1.13
  resource "optarg" do
    url "https://github.com/amberframework/optarg/archive/refs/tags/v0.9.3.tar.gz"
    sha256 "0d31c0cfdc1c3ec1ca8bfeabea1fc796a1bb02e0a798a8f40f10b035dd4712e9"

    # PR ref: https://github.com/amberframework/optarg/pull/6
    patch do
      url "https://github.com/amberframework/optarg/commit/56b34d117458b67178f77523561813d16ccddaf8.patch?full_index=1"
      sha256 "c5d9c374b0fdafe63136cd02126ac71ce394b1706ced59da5584cdc9559912c8"
    end
  end

  # patch granite to fix db dependency resolution issue
  # upstream patch https://github.com/amberframework/amber/pull/1339
  patch do
    url "https://github.com/amberframework/amber/commit/20f95cae1d8c934dcd97070daeaec0077b00d599.patch?full_index=1"
    sha256 "ad8a303fe75611583ada10686fee300ab89f3ae37139b50f22eeabef04a48bdf"
  end

  def install
    (buildpath/"optarg").install resource("optarg")
    (buildpath/"shard.override.yml").write <<~EOS
      dependencies:
        optarg:
          path: #{buildpath}/optarg
    EOS

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    llvm = Formula["llvm"]
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib if DevelopmentTools.clang_build_version >= 1500

    system "shards", "install"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/amber new test_app")
    %w[
      config/environments
      amber.yml
      shard.yml
      public
      src/controllers
      src/views
      src/test_app.cr
    ].each do |path|
      assert_match path, output
    end

    cd "test_app" do
      build_app = shell_output("shards build test_app")
      assert_match "Building", build_app
      assert_predicate testpath/"test_app/bin/test_app", :exist?
    end
  end
end
