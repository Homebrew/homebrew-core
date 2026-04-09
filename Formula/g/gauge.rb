class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.29.tar.gz"
  sha256 "a7de960830b4f8ec7f4095d5acd5c6d72104c86974bc5f79ce32893d785d85b7"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "573e71fc65bf53e1a13249efece101a2d95e0f148bcb646f9727328290d48d73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "373b207fc777f34c3998434b9b49592e53a0c20d4885360b584a22c4eaf8aaef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d2643c042e1a05f7302673eabde2f1906e185d703d5615c853b251a0e7e10a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "35d5209d0d7348262f2979d6c2786ec2ad336e935de0096e8b63e511cc7c0740"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d567c8ce9ac0c80c58131157296e2633ec8aec7a5c734c534eab47810c76ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bd137fa5d9d9e1c5eeaf4cdbf716f94f688cbf42f5cc49267b0d6f3334acc71"
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
