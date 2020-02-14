class Giter8 < Formula
  desc "Generate files and directories from templates in a git repo"
  homepage "https://github.com/foundweekends/giter8"
  url "https://search.maven.org/remotecontent?filepath=org/foundweekends/giter8/giter8-bootstrap_2.12/0.12.0/giter8-bootstrap_2.12-0.12.0.sh"
  sha256 "77cf4326076ab0c159b8370bb3c6980fd11b32180dc7a0559625bd07ba5aa393"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    bin.install "giter8-bootstrap_2.12-#{version}.sh" => "g8"
  end

  test do
    assert_match "g8 #{version}", shell_output("#{bin}/g8 --version")
    system "#{bin}/g8", "scala/scala-seed.g8", "--name=hello"
    assert_predicate testpath/"hello/build.sbt", :exist?
  end
end
