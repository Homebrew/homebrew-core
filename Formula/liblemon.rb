# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Liblemon < Formula
  desc "Library for Efficient Modeling and Optimization in Networks"
  homepage "http://lemon.cs.elte.hu"
  url "http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz"
  sha256 "71b7c725f4c0b4a8ccb92eb87b208701586cf7a96156ebd821ca3ed855bad3c8"
  depends_on "cmake" => :build
  # patch the preflow algorithm, see https://lemon.cs.elte.hu/trac/lemon/ticket/608
  patch :DATA
  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test liblemon`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
__END__
diff --git a/lemon/preflow.h b/lemon/preflow.h
index 28ccd67..d210e87 100644
--- a/lemon/preflow.h
+++ b/lemon/preflow.h
@@ -476,7 +476,7 @@ namespace lemon {
     /// Initializes the internal data structures and sets the initial
     /// flow to the given \c flowMap. The \c flowMap should contain a
     /// flow or at least a preflow, i.e. at each node excluding the
-    /// source node the incoming flow should greater or equal to the
+    /// source node the incoming flow should be greater or equal to the
     /// outgoing flow.
     /// \return \c false if the given \c flowMap is not a preflow.
     template <typename FlowMap>
@@ -495,7 +495,7 @@ namespace lemon {
         for (OutArcIt e(_graph, n); e != INVALID; ++e) {
           excess -= (*_flow)[e];
         }
-        if (excess < 0 && n != _source) return false;
+        if (_tolerance.negative(excess) && n != _source) return false;
         (*_excess)[n] = excess;
       }

@@ -639,7 +639,7 @@ namespace lemon {

           (*_excess)[n] = excess;

-          if (excess != 0) {
+          if (_tolerance.nonZero(excess)) {
             if (new_level + 1 < _level->maxLevel()) {
               _level->liftHighestActive(new_level + 1);
             } else {
@@ -720,7 +720,7 @@ namespace lemon {

           (*_excess)[n] = excess;

-          if (excess != 0) {
+          if (_tolerance.nonZero(excess)) {
             if (new_level + 1 < _level->maxLevel()) {
               _level->liftActiveOn(level, new_level + 1);
             } else {
@@ -791,7 +791,7 @@ namespace lemon {
       for (NodeIt n(_graph); n != INVALID; ++n) {
         if (!reached[n]) {
           _level->dirtyTopButOne(n);
-        } else if ((*_excess)[n] > 0 && _target != n) {
+        } else if (_tolerance.positive((*_excess)[n]) && _target != n) {
           _level->activate(n);
         }
       }
@@ -852,7 +852,7 @@ namespace lemon {

         (*_excess)[n] = excess;

-        if (excess != 0) {
+        if (_tolerance.nonZero(excess)) {
           if (new_level + 1 < _level->maxLevel()) {
             _level->liftHighestActive(new_level + 1);
           } else {

