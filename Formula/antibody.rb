class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v6.0.0.tar.gz"
  sha256 "40dbe2ff67117e63a8c98290c7a80f72e0cbd9cff2473a8b6d0eef45bd205443"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2b5acdc9642ab67fadac10c1923057d0aa46b0d6cea3ac764ed7521b71524d6" => :catalina
    sha256 "916ca7f7cc9ffe717fcba643ceaa9ef6c7fdc79fa1a444b0f3556921a1e2b419" => :mojave
    sha256 "fd0a48ebce0b42cd3ab3a5a3b757f9e0ff1d092820542c25023d6e6a1597bd88" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
