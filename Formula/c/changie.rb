class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "da365f000aacf5cfc19cfa7bf42cb2751a16722ddc237755bcbccb21ac39de46"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "415b25229f2f6001643104bb38e88a5b6d69f21edd51a3f272fba466b44426ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c2054b5806ebaa4c334630133fc4dfd9c4220a86580236d18e4b047b6eef5e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c2054b5806ebaa4c334630133fc4dfd9c4220a86580236d18e4b047b6eef5e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c2054b5806ebaa4c334630133fc4dfd9c4220a86580236d18e4b047b6eef5e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5368c47524415aa9e4e26e54957479396c530ddefd197b9b0b1d40718e80ff03"
    sha256 cellar: :any_skip_relocation, ventura:       "5368c47524415aa9e4e26e54957479396c530ddefd197b9b0b1d40718e80ff03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73b899d74730298d81313dd97bbc2e68a6ca234bcd10c0781023b9d5cf683be"
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
