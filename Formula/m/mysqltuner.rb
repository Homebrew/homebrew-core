class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "4923ca0a6184c6b3e77a98dd097f99cbdb3adaf334e45a9e4b5aa620cd83ae68"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98751a0d2ef92094e6b43cbc168cdb91747981b92f56705a0c0a47bb1e68b9b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98751a0d2ef92094e6b43cbc168cdb91747981b92f56705a0c0a47bb1e68b9b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98751a0d2ef92094e6b43cbc168cdb91747981b92f56705a0c0a47bb1e68b9b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "030ec7296fb4cd9f95fd85e2c1e33fdfedff8b7c80b3fce4596a0f322097438e"
    sha256 cellar: :any_skip_relocation, ventura:        "030ec7296fb4cd9f95fd85e2c1e33fdfedff8b7c80b3fce4596a0f322097438e"
    sha256 cellar: :any_skip_relocation, monterey:       "030ec7296fb4cd9f95fd85e2c1e33fdfedff8b7c80b3fce4596a0f322097438e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98751a0d2ef92094e6b43cbc168cdb91747981b92f56705a0c0a47bb1e68b9b2"
  end

  # upstream PR ref, https://github.com/major/MySQLTuner-perl/pull/757
  patch :DATA

  def install
    bin.install "mysqltuner.pl" => "mysqltuner"
  end

  # mysqltuner analyzes your database configuration by connecting to a
  # mysql server. It is not really feasible to spawn a mysql server
  # just for a test case so we'll stick with a rudimentary test.
  test do
    system "#{bin}/mysqltuner", "--help"
  end
end

__END__
diff --git a/mysqltuner.pl b/mysqltuner.pl
index 3a75531..4fa5193 100755
--- a/mysqltuner.pl
+++ b/mysqltuner.pl
@@ -1,3 +1,4 @@
+#!/usr/bin/env perl
 # mysqltuner.pl - Version 2.5.2
 # High Performance MySQL Tuning Script
 # Copyright (C) 2015-2023 Jean-Marie Renouard - jmrenouard@gmail.com
