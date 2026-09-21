class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.2.0.tar.gz"
  sha256 "fdb34c9394b589395a8c7b760640301ab30129d34c1b874f30060614ec490a66"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "44edd783c49cb8a7d07d668a45d3494c8d6191dd0dc409beca6bf1bc0d5dae72"
    sha256 arm64_tahoe:       "36f7fe195bdbc3d4b5691c9895934e7f6f0132a11e4e83479ee1bcb0e3a94348"
    sha256 arm64_sequoia:     "bc1b1869104f315a27befb890ef264d41587ea28f36326624296aa9bf3e6c1b1"
    sha256 arm64_linux:       "42932b65e5ab0911cdf09eab805f634b80559c80bf79cfe7c63f00b6361e198c"
    sha256 x86_64_linux:      "5be7c4fe1efcd4d17c47e2e712b85dade45aaf6f3d494097e3cc55a8a55c2621"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  deny_network_access! :test

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    system "bun", "run", "build"

    bin.install "dist/crowdin"
  end

  test do
    (testpath/"locale/en.json").write <<~JSON
      {"greeting": "Hello"}
    JSON

    (testpath/"crowdin.yml").write <<~YAML
      "project_id": "12"
      "api_token": "54e01--your-personal-token--2724a"
      "base_path": "."
      "base_url": "https://api.crowdin.com" # https://{organization-name}.crowdin.com

      "preserve_hierarchy": true

      "files": [
        {
          "source" : "/locale/*.json",
          "translation" : "/%two_letters_code%/%original_file_name%"
        }
      ]
    YAML

    assert_match "Your configuration file looks good",
      shell_output("#{bin}/crowdin config lint --config #{testpath}/crowdin.yml")

    rm testpath/"locale/en.json"

    assert_match "No source files found for '/locale/*.json' pattern",
      shell_output("#{bin}/crowdin config lint --config #{testpath}/crowdin.yml 2>&1", 2)
  end
end
