class GotoCli < Formula
  desc "Goto is an interactive command-line tool to manage your environments"
  homepage "https://github.com/LucienZhang/goto"
  url "https://github.com/LucienZhang/goto.git",
      tag:      "v1.0.0",
      revision: "989e852275acd62f832365c58e605b724add281b"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/LucienZhang/goto/configs.Version=#{version}"),
                          "-o", bin/"goto", "main.go"
  end

  test do
    version_out = shell_output("#{bin}/goto --version")
    assert_match "goto version " + version.to_s, version_out
  end
end
