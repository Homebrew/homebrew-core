class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      :tag      => "v0.11.0",
      :revision => "c7bdc2b94877e70d30fa8c05505672074f297144"

  bottle do
    cellar :any_skip_relocation
    sha256 "18dee69387e7a101967583d29541dc93a5fb65db526eaf04379109eb8625d408" => :mojave
    sha256 "8f10782b33daaabc306c43c9b10bb8eba09987aa9e15d94dee6ebde167e418d2" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
