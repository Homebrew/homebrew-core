class Beanstalkd < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://beanstalkd.github.io/"
  url "https://github.com/beanstalkd/beanstalkd/archive/v1.12.tar.gz"
  sha256 "f43a7ea7f71db896338224b32f5e534951a976f13b7ef7a4fb5f5aed9f57883f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeea48d399e95e86921751ed92aab3b378d065f99ba5d488dc2fffb0f44296a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a3ff3ad7d79b13d3df7b8048134f8e7321d2daf4fa61c80e57041dff7a3d5ec"
    sha256 cellar: :any_skip_relocation, monterey:       "bb7641f1326a43f92d8fd585b9678a52a02e88f6f1519001f431c565e0feb023"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d2a2ae37dc5914fc8f9a81973e056d5d310a12e87ab089a97f47d0fa8a6168b"
    sha256 cellar: :any_skip_relocation, catalina:       "eb308ce225c6f335a5a27518b63f8ce70caa263e94afbb7d9c2bb9000c12d974"
    sha256 cellar: :any_skip_relocation, mojave:         "da06f9b4142a163f26de89e5d67c729fd4edd9fbd2dcf3ada91507f92f45ec93"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d57a1db5de295181c1f5596951160cc65b7f27645806fb35834f6409cbc57a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a15f72d4f8afb377d6610eb9c1a1e1c0006c080807fadd9ca05cc02360fa533"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  service do
    run opt_bin/"beanstalkd"
    keep_alive true
    working_dir var
    log_path var/"log/beanstalkd.log"
    error_log_path var/"log/beanstalkd.log"
  end

  test do
    system "#{bin}/beanstalkd", "-v"
  end
end
