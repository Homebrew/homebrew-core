class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      :tag      => "v0.8.5",
      :revision => "e08b1ad4948f8bab44d1898b8707fffc2de0a690"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd88afef20d985377465de1422be8235fd9f04a82dfad5f147442f7b9400d286" => :mojave
    sha256 "138dc120fa48d6ff1dcfa002e4b1dd3ca701c1b2b9412e03a454119abd31568c" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match "0.8.5", shell_output("#{bin}/needle version")
  end
end
