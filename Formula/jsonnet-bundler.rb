class JsonnetBundler < Formula
  desc "Jsonnet package manager"
  homepage "https://github.com/jsonnet-bundler/jsonnet-bundler"
  url "https://github.com/jsonnet-bundler/jsonnet-bundler/archive/v0.1.0.tar.gz"
  sha256 "7ad25415358b2fd86bac05593ec2e90d9d87df17387fa8fbf4e21b8c06fe9779"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jsonnet-bundler/jsonnet-bundler").install buildpath.children

    cd "src/github.com/jsonnet-bundler/jsonnet-bundler" do
      system "go", "build", "-o", bin/"jb", "-installsuffix", "cgo",
                   "./cmd/jb"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/jb 2>&1")
    assert_match "A jsonnet package manager", output
    system bin/"jb", "init"
    assert_match "{}", shell_output("cat jsonnetfile.json 2>&1")
  end
end
