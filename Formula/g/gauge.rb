class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/refs/tags/v1.6.33.tar.gz"
  sha256 "f82cac175711ab1cc3cb8c6d7ed6ec7158ea55c63cbdc4d5752ef2b160badddf"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "268c6a83bad7b713a20a98d15bef76041abdb7f0bba3421a7c321727068c3e3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea9fcb5c8b5c84cf292a3f9f7ac4aeaf9e4dbca3a63be38d4930c3c48f5fd886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "623405cf0f96927f493e8ccd5cba27df0641c40b58d1b4e527e5d6e273107c0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1b0703b7dd2823a483af57326c66a763987f6b9d1228a3423c1bd5254890ea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9320b793f8455d665c097ba062cccae3a0adf5bdd79819f7fc32af87e8e9a679"
    sha256 cellar: :any,                 x86_64_linux:  "64407e596f7a6be9b2b780b34726b3f158014c2e8569dbcdde73d86c0e599835"
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
