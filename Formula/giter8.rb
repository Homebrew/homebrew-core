class Giter8 < Formula
  desc "Generate files and directories from templates in a git repo"
  homepage "https://github.com/foundweekends/giter8"
  url "https://search.maven.org/remotecontent?filepath=org/foundweekends/giter8/giter8-bootstrap_2.12/0.13.1/giter8-bootstrap_2.12-0.13.1.sh"
  sha256 "f3465f6b69a68c4cc67086446e6f583af3a243b2541e64dc32122a94999d29e0"
  license "Apache-2.0"

  bottle :unneeded

  disable! date: "2020-07-30", because: "fetches unversioned dependencies at runtime"

  depends_on "openjdk"

  def install
    bin.install "giter8-bootstrap_2.12-#{version}.sh" => "g8"
  end

  test do
    assert_match "g8 #{version}", shell_output("#{bin}/g8 --version")
    system "#{bin}/g8", "scala/scala-seed.g8", "--name=hello"
    assert_predicate testpath/"hello/build.sbt", :exist?
  end
end
