class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.12.tar.gz"
  sha256 "6bc51d54587234b8d223c392ec9c88478780de4ae5851d493ab10acaacf65ed1"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "20e9694f273ff53268b679a0fd068ebb3c1aee284232aae079a60e1641beb5cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55c7e709c07a5611634d54925fc457b7d1ef199913e2c2452c74597f005466b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28820935ff881cb175dd68db249241b33b470ff5a112441f34e94f17869852a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63289331b1fcee840c80627e90ab7161071332e653bda826057a1add291d19d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ba85c273ba563633f4c2b20ca74f2e74e8c8be82a321bd521b7831f8b986ac8"
    sha256 cellar: :any_skip_relocation, ventura:        "b1ad375442dd98976d82054f1fdd8af6e68c3923fadde7537d9f394bd3828946"
    sha256 cellar: :any_skip_relocation, monterey:       "4b86011e1e5292846ae6886d432830fc3be8aba954589e3ab20549acc2d5c1df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63a095a734201c7a6bb43e49cbd3c925514308a4876b1c1a9c25af57548c594"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
      -X github.com/simonwhitaker/gibo/cmd.commit=brew
      -X github.com/simonwhitaker/gibo/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", "completion")
  end

  test do
    system bin/"gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
