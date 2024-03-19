class Bomber < Formula
  desc "Scans Software Bill of Materials for security vulnerabilities"
  homepage "https://github.com/devops-kung-fu/bomber"
  url "https://github.com/devops-kung-fu/bomber/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "f5bc3af8ea376a3cf4a2feadf33d6be7f9fb0da7371960c11dd70ace67dc92c5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "561c778aa6ee3a824570fdec4bd10cd463e867415287121a090cb775532716fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c922a49987292cacbc2fa1062aa818aa13338a2ba8324febb784b147da4fc116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74d385ac5a65de4e55de6ff45d79131be4e5b563c34924ed8f78377678b23a83"
    sha256 cellar: :any_skip_relocation, sonoma:         "08a2e6678b102116e45f79e71c84b0da1a624742619bfad98cabf0d292bc512a"
    sha256 cellar: :any_skip_relocation, ventura:        "3b4eec0105996b01c15e203cdec74e38604b3521753c03adf82c5919e05c7aee"
    sha256 cellar: :any_skip_relocation, monterey:       "09372badd15cfa7fb295f22b4b53c37c51092dfa2ef2d65b6f6a2f3de817f1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "232b2c8792a49d2a3146ec3b3b6c5ee4148920d482e2403dddb8787a31f5deff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bomber", "completion")

    pkgshare.install "_TESTDATA_"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bomber --version")

    cp pkgshare/"_TESTDATA_/sbom/bomber.spdx.json", testpath
    output = shell_output("#{bin}/bomber scan bomber.spdx.json")
    assert_match "Total vulnerabilities found:", output
  end
end
