class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa.git",
      :tag      => "v0.10.1",
      :revision => "6c39555de1feda5b3650397b9a752bc59621c7ac"
  revision 1
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8f3c750a3e0a598cb98b4e243e9fbbab0af152dfe2c161aeda695dd50482bae" => :mojave
    sha256 "984600d03971491fa38c132713665a2829149693e75daf53dc60b80e20042005" => :high_sierra
    sha256 "f3f31c3a2ed1edabf26cb1aa862c9338f99343c7c0f1e412e40ce2b4d4773d2f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/open-policy-agent/opa").install buildpath.children

    cd "src/github.com/open-policy-agent/opa" do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      timestamp = Utils.popen_read("date -u +\"%Y-%m-%dT%H:%M:%SZ\"").chomp
      hostname = Utils.popen_read("hostname -f").chomp
      ldflags = "-X github.com/open-policy-agent/opa/version.Version=#{version}"\
                " -X github.com/open-policy-agent/opa/version.Vcs=#{commit}"\
                " -X github.com/open-policy-agent/opa/version.Timestamp=#{timestamp}"\
                " -X github.com/open-policy-agent/opa/version.Hostname=#{hostname}"

      system "go", "build", "-o", bin/"opa", "-installsuffix", "static",
                   "-ldflags",
                   ldflags

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
