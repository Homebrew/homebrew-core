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
    rebuild 1
    sha256 arm64_golden_gate: "c1a97a7f8fac98c42486464d9d871b0aeaa8afd1fa60f653b1a92fa13f042f4e"
    sha256 arm64_tahoe:       "f412879b759b91e87ddcf8c8efc4548318b73f17e84172d4fee90c124330a418"
    sha256 arm64_sequoia:     "c106b4016bbbc0d2213d2892aef6f6288a937088f6c1bbd775c31a8a90264d0b"
    sha256 arm64_linux:       "f0642cdefc217ad4cd50ab5c4770485c3b004d0485e18264c861fa1eadcd11e8"
    sha256 x86_64_linux:      "e687c27505fa603cff733c9e221d9041cb764045df6c92a9f69dcbc50ecbcece"
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
