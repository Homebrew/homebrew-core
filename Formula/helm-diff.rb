class HelmDiff < Formula
  desc "Helm plugin shows a diff explaing what a helm upgrade would change"
  homepage "https://github.com/databus23/helm-diff"
  url "https://github.com/databus23/helm-diff.git",
    :tag      => "v2.11.0+5",
    :revision => "33ee5a32d005db46d9efefeecb97d7b9aa125428"

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "kubernetes-cli"
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    dir = buildpath/"src/github.com/databus23/helm-diff"
    dir.install buildpath.children

    cd dir do
      system "glide", "install"
      system "go", "build", "-ldflags", "-s -w -X github.com/databus23/helm-diff/cmd.Version=#{version}",
        "-o", bin/"diff"

      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diff version")
  end
end
