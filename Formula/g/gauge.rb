class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.35.tar.gz"
  sha256 "6ac85da21c34bfdc20abb7fa137f69d6a66ba5947377aadb90c778eaf173ae73"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1262c6eb9070e786d9dad4463909b92338010d4fcd6e074fd833361c55626ffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c26ef4dbf5a0afd2385301b27e3b5ae24b2056dfae2682a59866b05328097a30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ff148c3dcabfaf29b4f5dab195766ad5212189f88f8fed5d0de8d2ff8740125"
    sha256 cellar: :any_skip_relocation, sonoma:        "d41d9e76ef633a30595b56f99453d80fbfcfbd6df03d03e7c97f01a498a30203"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecea08a41c354bf37a090df8d937c82dd1fe0c6a893d6916890541da77473daa"
    sha256 cellar: :any,                 x86_64_linux:  "84a02cab82e255fa8ef4d3555f4ad0aa2e6a64045c8462c07df5b67409584f23"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
