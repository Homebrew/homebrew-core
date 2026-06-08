class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "2f9ccdb83621530ebda4d22373554af45eeb550d32924a82249dbc66cb867726"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ce7af07dc44415cdfed0f1cfbc5ce1b742cb2d79b22cdebf4598e50baf7f1f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ce7af07dc44415cdfed0f1cfbc5ce1b742cb2d79b22cdebf4598e50baf7f1f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ce7af07dc44415cdfed0f1cfbc5ce1b742cb2d79b22cdebf4598e50baf7f1f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d541446d59262d79dc73caddd565430e5e70eb66aeea54d792af7bb516a40dac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d120e2c17beb148344666f41f7d6cd3f656188e82108dede92b123d54f1f59b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39477e9220efcad3687bab295231fab1b5dc1937c78b4b60269fb2df6792d79b"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"autorestic", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autorestic --version")

    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2

    (testpath/".autorestic.yml").write config.to_yaml
    (testpath/"repo/test.txt").write("This is a testfile")

    system bin/"autorestic", "check"
    system bin/"autorestic", "backup", "-a"
    system bin/"autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo/test.txt", testpath/"restore"/testpath/"repo/test.txt"
  end
end
