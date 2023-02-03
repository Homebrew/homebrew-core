class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.7.5.tar.gz"
  sha256 "8fef2ac2e4de39a4c4e0668133455c1c30dd2a4b002f872a29a37dd44e321d80"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e247669bada22a51e8a7ee8739ce3a25fff1bf3f40b5979ebf3398386e44868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4af10bf0b5de0eb4ed52f6b9ac823045b04650baf90f8a0854662675786ecb19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5072482edf9bc91066bba07da96cfd4cd2de511e2d262f17c6ebe38bc4d8342"
    sha256 cellar: :any_skip_relocation, ventura:        "1af0cb1fd885abf210960ee8cba4d74da82cdcecbcaac216c9ccf710b20554c1"
    sha256 cellar: :any_skip_relocation, monterey:       "226204417620bf95ce12323e9007537485ac870ec36deb71123965dbe20640be"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1b3983670856dfd1397d0bfe14df72b0898ab720c02eda086f074d6d8ce3212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0e6cfbeb2c85036ae0379336fcef709e7dd4c254cba1407eec79310b1f35920"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    system "go", "build", *std_go_args, "./main.go"
    generate_completions_from_executable(bin/"autorestic", "completion")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2
    File.write(testpath/".autorestic.yml", config.to_yaml)
    (testpath/"repo"/"test.txt").write("This is a testfile")
    system "#{bin}/autorestic", "check"
    system "#{bin}/autorestic", "backup", "-a"
    system "#{bin}/autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/testpath/"repo"/"test.txt"
  end
end
