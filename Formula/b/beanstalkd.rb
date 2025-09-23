class Beanstalkd < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://beanstalkd.github.io/"
  url "https://github.com/beanstalkd/beanstalkd/archive/refs/tags/v1.13.tar.gz"
  sha256 "26292dcdc0a7011d2f8ad968612f2cd8b2ef07687224876015399ae85e9e5263"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3822e7705185398f263482d69e922ffee29ccc195eb491bcc765a020ac6728ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "74b984c41b74f63386b6125681be1f37529341179a754f0556ed9d2d621b9088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c0cd544f3007bc3fc55d863ddacab823698188bd12e8a5b15e71aa81d071f50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "128bb476a00fb682cbc27ce9859d44efdb752221458b8bc33dd358313f1dd54e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d00ef3ef848ab20b6a0e8673134ddda3711e3b7ade51d5a143920038081de2be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f814739b81709efe980fe1d740ad459aa74db08a8027907af4d76f912e8e4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "22599c35be1743c9dcb52fcf32aa04a2647ec8853857afbc6c2854e7b1d5c571"
    sha256 cellar: :any_skip_relocation, ventura:        "02424e9c82015053c1217768e20fa081e6d692ae82000de9c792b0e94d77cbaa"
    sha256 cellar: :any_skip_relocation, monterey:       "2d08f8d072061940b968de3f7b3f221dd4e18f083d96a85a3d33a1a2ad049d0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5fbf19ce7c3b3cd8d6681aa8da2f7d658fa81486277ca06bf6225ece4b28568"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3992100979d75afc23d85cdff92fbb3d0f2d662c0e5cb0ea3d5ed6b13aeb4533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e523cebb72efcd0e73c3c11cbf695f6b0a3486894b9c6f6ea4c7590dc6a59a77"
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
    system bin/"beanstalkd", "-v"
  end
end
