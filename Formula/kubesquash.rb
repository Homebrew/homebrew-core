class Kubesquash < Formula
  desc "Debugger for Kubernetes applications"
  homepage "https://github.com/solo-io/kubesquash"
  url "https://github.com/solo-io/kubesquash/releases/download/v0.1.6/kubesquash-osx"
  version "0.1.6"
  sha256 "acfd077d186202e4fd88ec6c96aa26130d86b2e6eae308ff7b000cc307ab1b2c"

  def install
    mv "kubesquash-osx", "kubesquash"
    bin.install "kubesquash"
  end

  test do
    system "#{bin}/kubesquash", "--help"
  end
end
