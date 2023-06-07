class MrubyCli < Formula
  desc "Build native command-line applications for Linux, MacOS, and Windows"
  homepage "https://github.com/hone/mruby-cli"
  url "https://github.com/hone/mruby-cli/archive/v0.0.4.tar.gz"
  sha256 "97d889b5980193c562e82b42089b937e675b73950fa0d0c4e46fbe71d16d719f"
  license "MIT"
  head "https://github.com/hone/mruby-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4495dfded8fc9a3f3f90961612d6943113b3cc81b787e0cba2d4eadab304cd08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53b4a66eed494c2bd2e66d41dd5fe7d9f0332a866a0d7d39b6a77557717a35f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac082ff3a558eba68662a837eba2a9dfed46d52b757bb0e0b046b6a4d2d1105a"
    sha256 cellar: :any_skip_relocation, ventura:        "cf56c32770f4c9e65be960b9ae93fc65ff51b13d78d4b1a4f289c1b0a0eb5668"
    sha256 cellar: :any_skip_relocation, monterey:       "5c60103d037511f0808f55b744aea92a2b404160c0d268624ba8204bfbb5a62c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e15510585f6f0d64a93288218ab267281230937d0c97dc6982913683641bc98b"
    sha256 cellar: :any_skip_relocation, catalina:       "0418ca77d1a6adeaaf3184e9cbd566bab2829f2f736cc0f7f07ecf79e3bb6195"
    sha256 cellar: :any_skip_relocation, mojave:         "232802e1ee21a4c1d3790272414914f9d5b7ab073a2fd819c9ef5fc6872a165f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "267baff54cace7684edd4184625afd6fb788cdb072035e88b9c10e4d274454fe"
    sha256 cellar: :any_skip_relocation, sierra:         "d436b8d717f89db9807338345f4b0f385abcfc45f56e9b0b7decc333d4d05ad6"
    sha256 cellar: :any_skip_relocation, el_capitan:     "2f56375783e9365bafc0868d505b54eea315f6dad9a0095decbbd61abeb345ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826d12cb63bd84483619ef0c51ebbd4cd90a7becb3e3110ed661ba20a4be2f61"
  end

  deprecate! date: "2022-04-28", because: :unmaintained

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "ruby@2.7" => :build
  end

  def install
    ENV["MRUBY_CLI_LOCAL"] = "true"

    # Edit config to skip building Linux and Windows binaries
    rm buildpath/"build_config.rb"

    (buildpath/"build_config.rb").write <<~EOS
      MRuby::Build.new do |conf|
        toolchain :#{(ENV.compiler == :gcc) ? "gcc" : "clang"}

        conf.gem File.expand_path(File.dirname(__FILE__))
        conf.gem :github => 'iij/mruby-io'
      end
    EOS

    system "rake", "compile"
    bin.install "mruby/build/host/bin/mruby-cli"
  end

  test do
    system "#{bin}/mruby-cli", "--setup=brew"
    assert File.file? "brew/mrblib/brew.rb"
    assert File.file? "brew/tools/brew/brew.c"
  end
end
