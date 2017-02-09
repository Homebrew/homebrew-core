class Ec2backup < Formula
  desc "Simple AWS EC2 backup command line application for MacOS, Windows and Linux"
  homepage "https://github.com/tanis2000/ec2backup"
  url "https://github.com/tanis2000/ec2backup/archive/v0.1.1.tar.gz"
  sha256 "555ddbf513f956699564254ec368db0b4c628319aaee957feb905b7860b8020f"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath.to_s
    mkdir_p buildpath/"src/github.com/tanis2000"
    ln_s buildpath, buildpath/"src/github.com/tanis2000/ec2backup"
    system "go", "install", "github.com/tanis2000/ec2backup"
    bin.install "#{buildpath}/bin/ec2backup"
  end

  test do
    system "#{bin}/ec2backup", "--version"
  end
end
