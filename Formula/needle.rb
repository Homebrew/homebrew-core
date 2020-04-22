class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      :tag      => "v0.14.0",
      :revision => "626bcbb2751ae314850faa54484294dd660e9c70"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f4a9a2262bc49c96e85bbd999a097bc74b59171e82a7a01dde0a7030545b079" => :catalina
    sha256 "9fde1c441ff632e05f01b0342b03b91910841299026022d5305fe69c61dc77e6" => :mojave
    sha256 "6ed73b384d8bf6243d1dff0f8718d1163ac2348eb9ae8f9c1149b8413bfd0872" => :high_sierra
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
