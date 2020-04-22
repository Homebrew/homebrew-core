class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/6.1.tar.gz"
  sha256 "22c953ea1054c356663b31c77114c2f0c8fec17e0e707aeec23026241beab9b2"

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "tlx"

  patch :DATA

  def install
    mkdir "build" do
      system "cmake", ".", *std_cmake_args,
                           "-DNETWORKIT_EXT_TLX=#{Formula["tlx"].opt_prefix}",
                           "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_prefix}/include'",
                           "-DOpenMP_CXX_LIB_NAMES='omp'",
                           "-DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_prefix}/lib/libomp.dylib",
                           ".."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <networkit/graph/Graph.hpp>
      int main()
      {
        // Try to create a graph with five nodes
        NetworKit::Graph g(5);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", "-std=c++11"
    system "./test"
  end
end

__END__
diff --git a/include/networkit/randomization/DegreePreservingShuffle.hpp b/include/networkit/randomization/DegreePreservingShuffle.hpp
index ac0ebb607..70368eeb2 100644
--- a/include/networkit/randomization/DegreePreservingShuffle.hpp
+++ b/include/networkit/randomization/DegreePreservingShuffle.hpp
@@ -1,5 +1,5 @@
 /*
- * DegreePreservingShuffle.h
+ * DegreePreservingShuffle.hpp
  *
  *  Created on: 21.08.2018
  *      Author: Manuel Penschuck <networkit@manuel.jetzt>
@@ -33,7 +33,7 @@ namespace NetworKit {
  *  @node If you want to use it as a preprocessing step to GlobalCurveball, it's more
  *  efficient to set degreePreservingShufflePreprocessing in GlobalCurveball's constructor.
  */
-class DegreePreservingShuffle : public Algorithm {
+class DegreePreservingShuffle final : public Algorithm {
 public:
     DegreePreservingShuffle() = delete;
 
@@ -71,7 +71,7 @@ public:
     bool isParallel() const override final { return true; }
 
 private:
-    const Graph &G;
+    const Graph *G;
     std::vector<node> permutation;
 };

diff --git a/networkit/cpp/randomization/DegreePreservingShuffle.cpp b/networkit/cpp/randomization/DegreePreservingShuffle.cpp
index f744da014..d8c946690 100644
--- a/networkit/cpp/randomization/DegreePreservingShuffle.cpp
+++ b/networkit/cpp/randomization/DegreePreservingShuffle.cpp
@@ -2,7 +2,7 @@
  * CurveballUniformTradeGenerator.cpp
  *
  *  Created on: 01.06.2019
- *  	Author: Manuel Penschuck <networkit@manuel.jetzt>
+ *    Author: Manuel Penschuck <networkit@manuel.jetzt>
  */
 // networkit-format
 #include <omp.h>
@@ -137,7 +137,7 @@ static std::vector<index> computePermutation(std::vector<NodeDegree<DegreeT>> &n
 }
 } // namespace DegreePreservingShuffleDetails

-DegreePreservingShuffle::DegreePreservingShuffle(const Graph &G) : G{G} {}
+DegreePreservingShuffle::DegreePreservingShuffle(const Graph &G) : G(&G) {}
 DegreePreservingShuffle::~DegreePreservingShuffle() = default;

 std::string DegreePreservingShuffle::toString() const {
@@ -145,15 +145,15 @@ std::string DegreePreservingShuffle::toString() const {
 }

 void DegreePreservingShuffle::run() {
-    const auto n = G.numberOfNodes();
+    const auto n = G->numberOfNodes();

-    if (G.isDirected()) {
+    if (G->isDirected()) {
         // generate sequence of tuple (u, deg(u)) for each u
         std::vector<DegreePreservingShuffleDetails::DirectedNodeDegree> nodeDegrees(n);

-        G.parallelForNodes([&](const node u) {
+        G->parallelForNodes([&](const node u) {
             nodeDegrees[u].id = u;
-            nodeDegrees[u].degree = {G.degreeIn(u), G.degreeOut(u)};
+            nodeDegrees[u].degree = {G->degreeIn(u), G->degreeOut(u)};
         });

         permutation = DegreePreservingShuffleDetails::computePermutation(nodeDegrees);
@@ -162,9 +162,9 @@ void DegreePreservingShuffle::run() {
         // generate sequence of tuple (u, deg(u)) for each u
         std::vector<DegreePreservingShuffleDetails::UndirectedNodeDegree> nodeDegrees(n);

-        G.parallelForNodes([&](const node u) {
+        G->parallelForNodes([&](const node u) {
             nodeDegrees[u].id = u;
-            nodeDegrees[u].degree = G.degree(u);
+            nodeDegrees[u].degree = G->degree(u);
         });

         permutation = DegreePreservingShuffleDetails::computePermutation(nodeDegrees);
@@ -172,10 +172,13 @@ void DegreePreservingShuffle::run() {
 }

 Graph DegreePreservingShuffle::getGraph() const {
-    const auto n = G.numberOfNodes();
+    const auto n = G->numberOfNodes();
     assert(permutation.size() == n);
+    std::vector<node> local_perm;
+    local_perm.reserve(G->numberOfNodes());
+    G->forNodes([&](node u) { local_perm.push_back(permutation[u]); });

-    return GraphTools::getRemappedGraph(G, n, [this](node u) { return permutation[u]; });
+    return GraphTools::getRemappedGraph(*G, n, [&](node u) { return local_perm[u]; });
 }

 } // namespace NetworKit


