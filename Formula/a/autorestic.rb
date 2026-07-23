class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "2f9ccdb83621530ebda4d22373554af45eeb550d32924a82249dbc66cb867726"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f21af72312fc4c5b3e77d2d70f4c19a814bc7e8de42f5a3d368db39b4c60abcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f21af72312fc4c5b3e77d2d70f4c19a814bc7e8de42f5a3d368db39b4c60abcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f21af72312fc4c5b3e77d2d70f4c19a814bc7e8de42f5a3d368db39b4c60abcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "23cd822d5a4f674a0bc9e60974e6cf37e98ddc5077a6f938f5dffc397ccaddb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7a0741f2db1dcd936737919762484bfb1b39dbf91dc01516677248d402a5fec"
    sha256 cellar: :any,                 x86_64_linux:  "92320648e3ee73f5550712054f97cf54345d5da8d0106ee3c7d8de3c583ae73e"
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

    # `autorestic restore` recreates the absolute source path; on Linux CI restic then fails to
    # chown the root-owned parents (/var, /var/tmp). Read the file back with `restic dump` instead.
    ENV["RESTIC_PASSWORD"] = "secret"
    output = shell_output("#{formula_opt_bin("restic")}/restic -r #{testpath}/data " \
                          "dump latest #{testpath}/repo/test.txt")
    assert_equal "This is a testfile", output.chomp
  end
end
