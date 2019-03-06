class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      :tag      => "v0.9.0",
      :revision => "8fad4bdb3f6bf30408543f7b1c2b590f09ca6b39"

  bottle do
    cellar :any_skip_relocation
    sha256 "85eeb9823bb921011090ac9f3d03859da4e8799815601191dc8096782ac4cd1e" => :mojave
    sha256 "7a94d05e63913eaa6527dbd5fbad96e1d572b6fed270d7d2136440206e2829a2" => :high_sierra
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
