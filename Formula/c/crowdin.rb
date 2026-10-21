class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.4.0.tar.gz"
  sha256 "e0c7df6ad2dfee4e687a5aef0e303f7f7c3e50e50882d642d23878ff124e5d83"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "0181a0d7fdb34dc9d43a41fd3a79da18c8540e099e4d090083b2c18ef1c15bc8"
    sha256 arm64_tahoe:       "e6c080dc6ee747078d2d57d3bef857231c517716519c8c716df55636100c2530"
    sha256 arm64_sequoia:     "e6d3958f5d73ea51b92e46b23470248c836b0ee15dc52ead8db0e291e7148ee4"
    sha256 arm64_linux:       "8e1255d8c0a8a661d923f273527e9381084675c23b0b7fd277fef88e058bdcb4"
    sha256 x86_64_linux:      "6d24ac3ccd8b7177ea64e8de66bb84b7f9433c57e263c18c8f9a3903cb043e03"
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
