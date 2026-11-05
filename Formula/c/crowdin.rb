class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.6.0.tar.gz"
  sha256 "7092ca11e203904ee37a976c09ec99e31c09524ad0aa767d04433344d6f1306a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "7af07c7d740f895275772ac69ad2cef8509893571a38e745da02e1841ba79f29"
    sha256 arm64_tahoe:       "f1d6b9e215c1161a912a3cd6584eb580a48d1ac6a1ecc6de5ea136d7bfa2e0ed"
    sha256 arm64_sequoia:     "bfca94d32f4146c1e48f7357e9e7dbd822fefabeffa129ead05ccbb725594c64"
    sha256 arm64_linux:       "e02784c5444bf96990b0b19752f8c2598bff53a3f1bc5d45369a864c302dd4f6"
    sha256 x86_64_linux:      "3c38187ea1b1eb3f7dc34b4f1299b6907a958e711661f7bfef18acecbd458764"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@79"
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
