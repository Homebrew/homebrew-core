class Cvc4 < Formula
  desc "Efficient automated theorem prover for SMT problems."
  homepage "https://cvc4.cs.stanford.edu/web/"
  url "https://cvc4.cs.stanford.edu/downloads/builds/x86_64-macos-opt/cvc4-1.5-x86_64-macos-10.12-opt"
  version "1.5"
  sha256 "70f7673eb8243c612925e0f20456dd0e639e8a96ecb1c165c22e4b8600a030d2"

  def install
    mv "cvc4-1.5-x86_64-macos-10.12-opt", "cvc4-1.5"
    bin.install "cvc4-1.5"
  end

  test do
    system "false"
  end
end
