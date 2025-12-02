class GitAppraise < Formula
  desc "Distributed code review system for Git repos"
  homepage "https://github.com/google/git-appraise"
  license "Apache-2.0"
  head "https://github.com/google/git-appraise.git", branch: "master"

  stable do
    url "https://github.com/google/git-appraise/archive/refs/tags/v0.7.tar.gz"
    sha256 "b57dd4ac4746486e253658b2c93422515fd8dc6fdca873b5450a6fb0f9487fb3"

    # Backport go.mod from https://github.com/google/git-appraise/pull/111
    patch :DATA
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d005b8ba84092cf355c62cca07583b63626cc49ac5ea5833c06d80c8a1c023e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "57018642d15c7cb5e4a6d1b897e3f1c369c1e81e22eb8dbdef0c6f6fdd8909d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47ed51bc965177d94d4d1ef000fa1b62d25e923f1ad569fff3298c42bfebf3da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "987bab897e08380d91b10c6fdd7202c7a8e067d1417fb9887196b6cb5cdde19c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "117d03b5537210ab8f3efa3a76ff1a29394e66125d005b13183b9414d322c101"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f41dadc38480e15a1e0b55ba01ffa62a24416321b3337802c40a44a81e61dbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "09591073fcb424c242c2e14c0aa4c9f5e47173b70b61041a56dc83869d92aa15"
    sha256 cellar: :any_skip_relocation, ventura:        "b4140f1103438c29899231dfe0b1cc289bc812c8d0e68bd7c827d10a68c1c900"
    sha256 cellar: :any_skip_relocation, monterey:       "ad050720c5681456f47cef2988332445afe205a3c952f00fce6f12f831eb16de"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf48e84b761a284f1479fc5d3073ad19ed895d4718119cb175ca953246d98468"
    sha256 cellar: :any_skip_relocation, catalina:       "c09bd9a262807d81e959f60445ab6e60ec75907ea448306644efbb9eb9d62b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bb8623ee674ac49073c4ed1cbb2fae7d8903f6d9f7285b61e3688edcee74bda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c1748a7102d5350cf74a90a05706b2a8d6fc6fcc90cce7e823856c183ad4e46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-appraise"
  end

  test do
    system "git", "init", "--initial-branch=master"
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
    assert_path_exists testpath/".git/refs/notes/devtools/reviews"
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
