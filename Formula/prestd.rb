class Prestd < Formula
  desc "Simplify and accelerate development, ⚡ instant, realtime, high-performance on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.5.tar.gz"
  sha256 "a11aad345212e12d461fbe5410e25be0e1c934f6c7afec50307f6520adb33240"
  license "MIT"
  head "https://github.com/prest/prest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72637c929700df77fb813dd4bc8300774e4b2510d761b701416cc33dbb5f0a3c" => :big_sur
    sha256 "1e7874a2cf67448b62447eba3b9d81c39e40a0fccefc093e71979ce484209f5d" => :arm64_big_sur
    sha256 "1d7280403f36a51dafeba47bc389ed9a3f57242f9c8d61e1341bc203aa8d3e3f" => :catalina
    sha256 "4e053d872bab5d1f102f7a94fc2e8a314157e3dd35f1f624feddd9e7d5130f8f" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}",
      "./cmd/prestd"
  end

  test do
    output = shell_output("prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prestd version")
  end
end
