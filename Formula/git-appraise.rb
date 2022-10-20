class GitAppraise < Formula
  desc "Distributed code review system for Git repos"
  homepage "https://github.com/google/git-appraise"
  license "Apache-2.0"
  head "https://github.com/google/git-appraise.git", branch: "master"

  stable do
    url "https://github.com/google/git-appraise/archive/v0.7.tar.gz"
    sha256 "b57dd4ac4746486e253658b2c93422515fd8dc6fdca873b5450a6fb0f9487fb3"

    # Backport go.mod from https://github.com/google/git-appraise/pull/111
    patch :DATA
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "117d03b5537210ab8f3efa3a76ff1a29394e66125d005b13183b9414d322c101"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f41dadc38480e15a1e0b55ba01ffa62a24416321b3337802c40a44a81e61dbe"
    sha256 cellar: :any_skip_relocation, monterey:       "ad050720c5681456f47cef2988332445afe205a3c952f00fce6f12f831eb16de"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf48e84b761a284f1479fc5d3073ad19ed895d4718119cb175ca953246d98468"
    sha256 cellar: :any_skip_relocation, catalina:       "c09bd9a262807d81e959f60445ab6e60ec75907ea448306644efbb9eb9d62b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c1748a7102d5350cf74a90a05706b2a8d6fc6fcc90cce7e823856c183ad4e46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-appraise"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "user@email.com"
    (testpath/"README").write "test"
    system "git", "add", "README"
    system "git", "commit", "-m", "Init"
    system "git", "branch", "user/test"
    system "git", "checkout", "user/test"
    (testpath/"README").append_lines "test2"
    system "git", "add", "README"
    system "git", "commit", "-m", "Update"
    system "git", "appraise", "request", "--allow-uncommitted"
    assert_predicate testpath/".git/refs/notes/devtools/reviews", :exist?
  end
end

__END__
diff --git a/go.mod b/go.mod
new file mode 100644
index 00000000..28bed68b
--- /dev/null
+++ b/go.mod
@@ -0,0 +1,5 @@
+module github.com/google/git-appraise
+
+go 1.18
+
+require golang.org/x/sys v0.0.0-20220406163625-3f8b81556e12
diff --git a/go.sum b/go.sum
new file mode 100644
index 00000000..b22c466b
--- /dev/null
+++ b/go.sum
@@ -0,0 +1,2 @@
+golang.org/x/sys v0.0.0-20220406163625-3f8b81556e12 h1:QyVthZKMsyaQwBTJE04jdNN0Pp5Fn9Qga0mrgxyERQM=
+golang.org/x/sys v0.0.0-20220406163625-3f8b81556e12/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
