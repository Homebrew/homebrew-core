class NotionMdGen < Formula
  desc "Convert notion content to markdown for static blog"
  homepage "https://github.com/saltbo/notion-md-gen"
  url "https://github.com/saltbo/notion-md-gen.git",
      tag:      "v1.2.0",
      revision: "6db355b7e63ba8b0b745989f84ff42b8c65f4637"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
      "-s -w -X notion-md-gen/cmd.release=#{version} -X notion-md-gen/cmd.commit=#{Utils.git_head} -X notion-md-gen/cmd.repo=#{stable.url}",
      *std_go_args,
      "./main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/notion-md-gen version 2>&1")
  end
end
