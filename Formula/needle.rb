class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      tag:      "v0.15.0",
      revision: "f2bf540f14d671ad809548bcaea87cea21782d8f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "81c7cf7764f4a7293c96b9c3251d2f462ce278504631135f0288a5a2b4ea3956" => :catalina
    sha256 "38800eea19a89fcecdfe57fd7fc2fce85d4f1dfbe3b29437794d34b5523df32d" => :mojave
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
