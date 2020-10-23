class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.16.1",
      revision: "f89227736f31c0b0ceb444968d41ddf12c9849ae"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7de85300ed38569f08ff08c6de1315bcad2e56b839318bd6fabc3819e2ac872" => :catalina
    sha256 "47e77c9227481c025972d6e685882605afeefa074efe4011529df055b44cd289" => :mojave
  end

  depends_on xcode: ["11.3", :build]
  depends_on xcode: "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
