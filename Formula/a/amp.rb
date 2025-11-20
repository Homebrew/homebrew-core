class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/refs/tags/0.7.1.tar.gz"
  sha256 "59a65c2c4592eed188433fe7c4bf2ba84206f217bdafc5a2c7f97623f5607c12"
  license "GPL-3.0-or-later"
  head "https://github.com/jmacdonald/amp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ea7ee62194a805d8aac77d647b293612a22e742adc7ac3679a80ae138b9592a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a30d84cac91e6123f3e57142c390e206d50a81c85bb249918ed9d25722d85bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99da73190b5be3bab9813061219aaf060d73bc996a03b9fc194a77c93cc15159"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0f0821829385e973dae0f4112bb3378d5e358b69f6e51064874e1355ab37151"
    sha256 cellar: :any_skip_relocation, sonoma:        "552866e5376aa068d399a05e7aa92f0a8e39d8e1fe6418cd1614352902dc4959"
    sha256 cellar: :any_skip_relocation, ventura:       "b6a91b42ec2904a23ce679264886e2cbfdba31f97a5dc0b4dd66164a6d4178a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc1b33c3caff52184f6760a2adcd2f49048ded51708d4416988d5e26a2328d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7df552cbc8bfb5ae1f956eaaf1f32af1daf7e32000d4012897459f5885bb2bf"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    PTY.spawn(bin/"amp", "test.txt") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      # switch to insert mode and add data
      w.write "i"
      sleep 1
      w.write "test data"
      sleep 1
      # escape to normal mode, save the file, and quit
      w.write "\e"
      sleep 1
      w.write "s"
      sleep 1
      w.write "Q"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match "test data\n", (testpath/"test.txt").read
  end
end
