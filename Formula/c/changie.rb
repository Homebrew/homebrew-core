class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "42a82bd245016c6c78f747a336d4e3f81b430d89daf7ec75bf9dc2a4c05af3ad"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c73dd2f27d5a06fb3d2b484efb9d41a121498dff0b2b3263ae3bbda7f11846b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36d49a0e9e7b712c4f89c5031040136389d4aa973dc0b75a241dbfba588d41b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98dcb0ac7737184c87b1b26e8eeea396de8fc87d2c0f4342aed40a551bc02af7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b2afb4e6f25e5677b5cad76fcb292fa7ea0c12454a5fa1cb2d51f9f20887641"
    sha256 cellar: :any_skip_relocation, ventura:        "43b0691e1392c88f8dae4d32d0ec39ca5d68791db0e1782aa76e223c9029e8bc"
    sha256 cellar: :any_skip_relocation, monterey:       "3e8247075ec5e2b00ae8bf017f265f457c00a22e22816e2ea87d8ae80cf8c6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6806abe380b5d976d566a0f8f7d1298c77834319badb396c0cf678d3b52a3149"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
