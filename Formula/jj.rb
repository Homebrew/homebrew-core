class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "bea5980f6857370b93b396df03401f38f928400ac42ba8e757c86f34098956ce"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3bfda1803c30b4c35acd07f05ac3ae5581c3ba3d75820fbc0a9ee4aa7af1dfd1"
    sha256 cellar: :any,                 arm64_big_sur:  "875511053de73f5b907ac89a6fc0b13ef909352a85044709efe7bfa8ae2d7317"
    sha256 cellar: :any,                 monterey:       "1031326eba25ba0e583858fd31bea56691a0f42e554c087a34db050e1ce94bf8"
    sha256 cellar: :any,                 big_sur:        "eb64d12c0287bb853b559bd5513d77bc69d26eb66c98786f973872c746384a97"
    sha256 cellar: :any,                 catalina:       "86a85e719dab445556bb988267c82afca58c7fae595d7f40b3d1e11e4f328cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "094880212c087dda873fd4154b3c444655415a5c9db382b6c23e7026ca77e882"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
