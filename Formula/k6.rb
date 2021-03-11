class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.31.0.tar.gz"
  sha256 "1033faaeb3ede03c069bc487dcc36f9fe1ae349a33777d8c1930bafd88be3a7f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9188e1dc69294c2f6066e9d81ec3f211fa6388645c1daab9e5a5ff57dc9912e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "2137c88a32ac557df0d8738c18d010772ebde7467bcdc97c55c71cf7b6696b79"
    sha256 cellar: :any_skip_relocation, catalina:      "9417f296cc2f5a7e360f466577ab4a001dc0b8ed5ea99fb998280eeae39a13a1"
    sha256 cellar: :any_skip_relocation, mojave:        "ada361abbd7089c348837364177526524198ccb569468cadb9b01b95ac20a9c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
