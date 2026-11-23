class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.18.tar.gz"
  sha256 "1828028e4a8b3234038a2de4e2eccecf57a27a02eb0112a90eb16bbca9954ecd"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    manifest_sha256 "df7f5321913d587ba528eefa166befb4645a342ae80179aab458f24d97b0073b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e334ce715a602f459d319ffd2b3a54cd3ee83c5a84e869674644c1c39fef7a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e334ce715a602f459d319ffd2b3a54cd3ee83c5a84e869674644c1c39fef7a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e334ce715a602f459d319ffd2b3a54cd3ee83c5a84e869674644c1c39fef7a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "133de67b0f9fbc1c464c21f46cecd63de6b0cc348003d567012645d43e5a1dc2"
    sha256 cellar: :any,                 x86_64_linux:      "c2581f2a93c3931a3ff056879cd66155ba60a6ebe6a783dc52acdb6f854d36e4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"ghorg", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
