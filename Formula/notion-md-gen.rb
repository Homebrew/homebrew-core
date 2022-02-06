class NotionMdGen < Formula
  desc "Convert notion content to markdown for static blog"
  homepage "https://github.com/bonaysoft/notion-md-gen"
  url "https://github.com/bonaysoft/notion-md-gen.git",
      tag:      "v1.0.0",
      revision: "72e0d380c7a6c1066aaf9e2dae551a0a92624cde"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X notion-md-gen/cmd.release=#{version}
      -X notion-md-gen/cmd.commit=#{Utils.git_head}
      -X notion-md-gen/cmd.repo=#{stable.url}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/notion-md-gen version 2>&1")
    assert_match "notion-md-gen.yaml", shell_output("#{bin}/notion-md-gen init 2>&1")
  end
end
