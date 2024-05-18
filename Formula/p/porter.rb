class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter.git",
      tag:      "v1.0.17",
      revision: "605e399737c5c89f0ce692c6aa3d9e6211250c95"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  depends_on "go" => :build

  def install
    git_head = Utils.git_short_head
    cd "cmd/porter" do
      ldflags = %W[
        -s
        -X get.porter.sh/porter/pkg.Version=#{version}
        -X get.porter.sh/porter/pkg.Commit=#{git_head}
      ]

      system "go", "build", *std_go_args(ldflags:)
      generate_completions_from_executable(bin/"porter", "completion")
      system "#{bin}/porter", "mixin", "install", "exec", "--version", "v#{version}"
    end
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    assert_match "Mixin commands. Mixins assist with authoring bundles.",
                  shell_output("#{bin}/porter mixin -h")

    system bin/"porter", "create"
    assert_predicate testpath/"porter.yaml", :exist?
  end
end
