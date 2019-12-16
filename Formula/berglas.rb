class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.5.0.tar.gz"
  sha256 "10e0754b034ce84c5783e494ddb5772265bc8b1cfaa1a13871521881c869b4b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "305e848eb3a7b671b10996b7b145ee8a41d46165c825450399497a920a92e759" => :catalina
    sha256 "f7df64d6b12b4fe6fa458aa9d9b5d979589c5e0da9a0cf0e545c59d732734806" => :mojave
    sha256 "e86deac6d0854b9dcdac69df25b5ce838c0ec9adf918c5855c457ff6a9975e95" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"berglas"
  end

  test do
    assert_match "#{version}\n", shell_output("#{bin}/berglas --version 2>&1")
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
