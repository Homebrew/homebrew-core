class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul/archive/v0.7.2.tar.gz"
  sha256 "c2b2723089f82f7b1623676fda8d378795bf87b4dbc6d4b297e5fc27aeab0aca"
  depends_on "go" => :build

  def install
    gopath = buildpath/"go"
    to_move = (Dir.entries buildpath).reject { |entry| entry.start_with? "." }
    mkdir_p gopath
    envconsul_path = gopath/"src"/"github.com"/"hashicorp"/"envconsul"
    mkdir_p envconsul_path
    to_move.each do |item|
      mv item, envconsul_path
    end

    ENV["GOPATH"] = gopath
    cd envconsul_path do
      system "go", "build"
    end
    bin.install envconsul_path/"envconsul"
  end

  test do
    system "#{bin}/envconsul", "-version"
  end
end
