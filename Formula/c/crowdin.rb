class Crowdin < Formula
  desc "Command-line tool that allows to manage your resources with crowdin.com"
  homepage "https://support.crowdin.com/cli-tool/"
  url "https://github.com/crowdin/crowdin-cli/archive/refs/tags/5.0.2.tar.gz"
  sha256 "c03f79e81f5dfcb434f1447ea10d3e7baa574afc892da4519a88581455e9f14c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b6979092c7e147cd4e20b70f040e54818bcd5605201e6337b4f42d034273657d"
    sha256 arm64_sequoia: "3dd066de39c0f3d0a9bc0d2200e56d7c4d629654cd3885663a393fabcc16c5f0"
    sha256 arm64_sonoma:  "fdf4eab59ba51f1926996891c32dc6f28d7096d3d014f593eb7ae20daaef5ae1"
    sha256 arm64_linux:   "22527f675bef45971b005279de99e9fc2fe9baa09a2e0ac1160c7b235a722381"
    sha256 x86_64_linux:  "c63c9f96fafe17ecdf99b940c3f17045408c6deb1b15728607806c572fc7fd9e"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@78"
  end

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
    (testpath/"crowdin.yml").write <<~YAML
      "project_id": "12"
      "api_token": "54e01--your-personal-token--2724a"
      "base_path": "."
      "base_url": "https://api.crowdin.com" # https://{organization-name}.crowdin.com

      "preserve_hierarchy": true

      "files": [
        {
          "source" : "/t1/**/*",
          "translation" : "/%two_letters_code%/%original_file_name%"
        }
      ]
    YAML

    assert "Failed to collect project info",
      shell_output("#{bin}/crowdin upload sources --config #{testpath}/crowdin.yml 2>&1", 102)
  end
end
