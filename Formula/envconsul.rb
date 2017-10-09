class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul/archive/v0.7.2.tar.gz"
  sha256 "c2b2723089f82f7b1623676fda8d378795bf87b4dbc6d4b297e5fc27aeab0aca"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/envconsul").install buildpath.children
    cd "src/github.com/hashicorp/envconsul" do
      system "go", "build", "-o", bin/"envconsul"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/envconsul", "-version"
  end
end
