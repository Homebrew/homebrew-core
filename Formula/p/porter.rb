class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "eb5451b85e50e4033a50101171f8c6372ffd2600361bd34fa2d1166a8d062742"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  depends_on "go" => :build

  def install
    cd "cmd/porter" do
      ldflags = %W[
        -s
        -X get.porter.sh/porter/pkg.Version=#{version}
        -X get.porter.sh/porter/pkg.Commit=#{tap.user}
      ]

      system "go", "build", *std_go_args(ldflags:)
      generate_completions_from_executable(bin/"porter", "completion")
      system bin/"porter", "mixin", "install", "exec", "--version", "v#{version}"
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
