class Pup < Formula
  desc "Parse HTML at the command-line"
  homepage "https://github.com/EricChiang/pup"
  url "https://github.com/ericchiang/pup/archive/v0.4.0.tar.gz"
  sha256 "0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0"
  license "MIT"
  head "https://github.com/EricChiang/pup.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6854a47afc836d12ed5447f9d285484e200f0d4350411f5aac7bf5e30f33a07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8933d95f5318154ec8f9e7d2080c24c3657d2c850935f9c165e485ad98ad6bff"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e7f5510d0f6a38934fae0c75c8f54949bb13b8a60e5536afa937e2a8951444"
    sha256 cellar: :any_skip_relocation, big_sur:        "929baa98965ce865620bc15bf4f5951dff558b0ad1f9e439d47faf92798f5405"
    sha256 cellar: :any_skip_relocation, catalina:       "f5f4f5c09cc76054eac2b96357f4b2aca8501daa8c805801d17079aa7e5395f8"
    sha256 cellar: :any_skip_relocation, mojave:         "1801647618fe8e2367ce3d739513c1811259bf1db3fb9ddfbc9301e559102d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "984ec42bb2a863b2afec7954b8b1c706a5474e0cbd278ed5e4f5439c13f02bb2"
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/ericchiang/pup"
    dir.install buildpath.children

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    cd dir do
      system "gox", "-arch", arch, "-os", os, "./..."
      bin.install "pup_#{os}_#{arch}" => "pup"
    end

    prefix.install_metafiles dir
  end

  test do
    output = pipe_output("#{bin}/pup p text{}", "<body><p>Hello</p></body>", 0)
    assert_equal "Hello", output.chomp
  end
end
