class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.0.2.tar.gz"
  sha256 "c03f79e81f5dfcb434f1447ea10d3e7baa574afc892da4519a88581455e9f14c"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "b1921f296610064faab165188d31f345d56b86a9b55e04b3e92ea780feba1b06"
    sha256 arm64_tahoe:       "f4785ae0793ebe7167f5d4cb3cedfd57836cef8a621aebcf40e9c6ea16354446"
    sha256 arm64_sequoia:     "b37a0d39fbb9e7cc91a527f0475968c05fc6d962d28a180720379b1dcefbfd07"
    sha256 arm64_linux:       "a080e4df4ac71cc168769f1c63bb90239dea628b9083571493f2e2b2805bf63f"
    sha256 x86_64_linux:      "ccf472654e93874bfcceb0f6e2f1644342522ec22b089b97f04c2a4e46712fa0"
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
