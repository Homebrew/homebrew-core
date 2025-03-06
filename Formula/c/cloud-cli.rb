class CloudCli < Formula
  desc "A tool for managing multi-service projects"
  homepage "https://github.com/this-is-allan/cloud-cli"
  url "https://github.com/this-is-allan/cloud-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0b142013f1ad2705e663c9220499ae101f904e1a594eac5e8aa3aac05bf46764"
  license "MIT"

  depends_on "jq"
  depends_on "tmux"

  def install
    bin.install "bin/cloud"
  end

  def post_install
    system "mkdir", "-p", "#{ENV["HOME"]}/.cloud"
    system "touch", "#{ENV["HOME"]}/.cloud/config.json"
    system "echo", "'{\"projects\": {}}'", ">", "#{ENV["HOME"]}/.cloud/config.json" unless File.size?("#{ENV["HOME"]}/.cloud/config.json")
  end

  test do
    assert_match "Cloud Project Manager", shell_output("#{bin}/cloud help")
  end
end