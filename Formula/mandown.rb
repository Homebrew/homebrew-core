class Mandown < Formula
  desc "Man-page inspired Markdown viewer"
  homepage "https://github.com/Titor8115/mandown"
  url "https://github.com/Titor8115/mandown/archive/v1.0.1.tar.gz"
  sha256 "b014a44b27f921c12505ba4d8dba15487ca2b442764da645cd6d0fd607ef068c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72f91c87b01ae0fb51ee58518fcb963201b8a833c09d7e81556f09bda80c553f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f06d6f6ada8676f6644e8491823bcb2310eaec516120b3455465ce4bd03a3dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0b7966c93183b64046728563d3f9f95fd54e836f74cd13560ea013f1261aee3"
    sha256 cellar: :any_skip_relocation, ventura:        "58b84452b3493987cfe1bf1c5db63e043f01f5822d23d8a95eb7b25b3b6d65aa"
    sha256 cellar: :any_skip_relocation, monterey:       "e4b32eed833a22db7e51e2cf957a4ed80ff8403d2959dce0b9af6242406a057c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd0e5fef1f35544524a29e7704d68ccce992ee099a34a088155c9fc579da5cf7"
    sha256 cellar: :any_skip_relocation, catalina:       "09ad2e54a3b54c9687580b4499f4c5247dfd2e18fb64230b3c255fbc7df1c5be"
    sha256 cellar: :any_skip_relocation, mojave:         "9186b868866dd17f080343297e145161f3fe6303701a12bd0a47f8ef246f6630"
    sha256 cellar: :any_skip_relocation, high_sierra:    "acf617ed0300f38b429ed05504c47bb9e403441316d335ae83bf28c18baa63a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5710fddef5906f57883d6fccbfd1078253dda88cc71c72ad707161bd8b6f01b3"
  end

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2" unless OS.mac?
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.md").write <<~EOS
      #Hi from readme file!
    EOS
    expected_output = <<~EOS
      <title >test.md(7)</title>
      <h1>Hi from readme file!</h1>
    EOS
    system "#{bin}/mdn", "-f", "test.md", "-o", "test"
    assert_equal expected_output, File.read("test")
  end
end
